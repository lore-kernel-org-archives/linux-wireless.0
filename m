Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16BADE;
	Fri,  1 Dec 2023 02:37:35 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 5755120645;
	Fri,  1 Dec 2023 11:37:34 +0100 (CET)
Date: Fri, 1 Dec 2023 11:37:32 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: David Lin <yu-hao.lin@nxp.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	briannorris@chromium.org, kvalo@kernel.org, francesco@dolcini.it,
	tsung-hsien.hsieh@nxp.com
Subject: Re: [PATCH v7 08/12] wifi: mwifiex: fixed the way to handle assoc
 timeout.
Message-ID: <ZWm3bPq8JbB9WiCs@francesco-nb.int.toradex.com>
References: <20231128083115.613235-1-yu-hao.lin@nxp.com>
 <20231128083115.613235-9-yu-hao.lin@nxp.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128083115.613235-9-yu-hao.lin@nxp.com>

On Tue, Nov 28, 2023 at 04:31:11PM +0800, David Lin wrote:
> Without this patch, if there is no association response from AP with host
> mlme enabled, kernel oops will occur.

As commented on previous patches this should be done in the commit that
introduce the host mlme feature in the first place

