Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD31E4;
	Sun, 10 Dec 2023 23:37:57 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 3055B2074F;
	Mon, 11 Dec 2023 08:37:53 +0100 (CET)
Date: Mon, 11 Dec 2023 08:37:49 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: David Lin <yu-hao.lin@nxp.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	briannorris@chromium.org, kvalo@kernel.org, francesco@dolcini.it,
	tsung-hsien.hsieh@nxp.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] wifi: mwifiex: add extra delay for firmware ready
Message-ID: <ZXa8TcmsQjXzbxI5@francesco-nb.int.toradex.com>
References: <20231208234029.2197-1-yu-hao.lin@nxp.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231208234029.2197-1-yu-hao.lin@nxp.com>

Hello David,
thanks for your patch.

On Sat, Dec 09, 2023 at 07:40:29AM +0800, David Lin wrote:
> For SDIO IW416, due to a bug, FW may return ready before complete
> full initialization.
> Command timeout may occur at driver load after reboot.
> Workaround by adding 100ms delay at checking FW status.
> 
> Signed-off-by: David Lin <yu-hao.lin@nxp.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Francesco

