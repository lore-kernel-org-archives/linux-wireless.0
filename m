Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2546196;
	Fri,  1 Dec 2023 02:43:51 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 2054C206C0;
	Fri,  1 Dec 2023 11:43:50 +0100 (CET)
Date: Fri, 1 Dec 2023 11:43:48 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: David Lin <yu-hao.lin@nxp.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	briannorris@chromium.org, kvalo@kernel.org, francesco@dolcini.it,
	tsung-hsien.hsieh@nxp.com
Subject: Re: [PATCH v7 12/12] wifi: mwifiex: fixed compile and coding errors.
Message-ID: <ZWm45Kicf5/D64Cm@francesco-nb.int.toradex.com>
References: <20231128083115.613235-1-yu-hao.lin@nxp.com>
 <20231128083115.613235-13-yu-hao.lin@nxp.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128083115.613235-13-yu-hao.lin@nxp.com>

On Tue, Nov 28, 2023 at 04:31:15PM +0800, David Lin wrote:
> 1. struct cfg80211_rx_assoc_resp -> struct cfg80211_rx_assoc_resp_data.
> 2. Pointer should be used for memcpy.

this is changing code that you just add on this series, no separate
patch.

Francesco

