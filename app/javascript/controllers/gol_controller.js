import { Controller } from "@hotwired/stimulus"
import { get, post, put, patch, destroy } from '@rails/request.js'
// Connects to data-controller="gol"
export default class extends Controller {
    static targets = ["clear", "export", "next", "random", "speed", "stall", "start", "stop", "table"]

    static values = {
        intervalId: Number
    }

    connect() {
    }

    async start() {
        this.disableClicks();
        this.startAliens();
        this.intervalIdValue = setInterval(async () => await this.run().catch(_err => this.stop()), +this.speedTarget.value);
        console.log("INTERVAL SET TO: " + this.intervalIdValue)
    }

    stop() {
        clearInterval(this.intervalIdValue)
        console.log("CLEARED ID: " + this.intervalIdValue);
        this.enableClicks();
        this.stopAliens();
    }

    async run() {
        const res = await post('/gol/next_gen', { responseKind: "turbo-stream", follow: "follow" });

        if (res.redirected) {
            this.stop();
            this.stallTarget.click();
            return;
        }
        if (!res.ok) this.stop();
        return res;
    }

    async toggle(event) {
        const data = event.target.dataset;
        console.log(data)
        const body = {
            cell: {
                x: data.row,
                y: data.col
            }
        }
        const response = await post('/update_cell', { body: JSON.stringify(body), responseKind: "turbo-stream" });
        if (response.ok) {
            console.log(response)
        }
    }

    disableClicks() {
        this.startTarget.style.display = 'none';
        this.stopTarget.style.display = 'block';
        this.tableTarget.classList.add('active');
        const buttons = [this.randomTarget, this.clearTarget, this.speedTarget, this.nextTarget, this.exportTarget];
        buttons.forEach(btn => btn.disabled = true);
    }

    enableClicks() {
        this.stopTarget.style.display = 'none';
        this.startTarget.style.display = 'block';
        this.tableTarget.classList.remove('active');
        const buttons = [this.randomTarget, this.clearTarget, this.speedTarget, this.nextTarget, this.exportTarget];
        buttons.forEach(btn => btn.disabled = false);

    }

    startAliens() {
        document.querySelectorAll('.alien').forEach(alien => alien.classList.add('active'));
    }

    stopAliens() {
        document.querySelectorAll('.alien').forEach(alien => alien.classList.remove('active'));
    }
}
