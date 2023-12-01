Received: from mail11.truemail.it (mail11.truemail.it [IPv6:2001:4b7e:0:8::81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1FAA8;
	Fri,  1 Dec 2023 02:18:44 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id BE40920645;
	Fri,  1 Dec 2023 11:18:42 +0100 (CET)
Date: Fri, 1 Dec 2023 11:18:41 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: David Lin <yu-hao.lin@nxp.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	briannorris@chromium.org, kvalo@kernel.org, francesco@dolcini.it,
	tsung-hsien.hsieh@nxp.com
Subject: Re: [PATCH v7 04/12] wifi: mwifiex: fixed missing WMM IE for assoc
 req.
Message-ID: <ZWmzAWlh7o4bLZB8@francesco-nb.int.toradex.com>
References: <20231128083115.613235-1-yu-hao.lin@nxp.com>
 <20231128083115.613235-5-yu-hao.lin@nxp.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128083115.613235-5-yu-hao.lin@nxp.com>

On Tue, Nov 28, 2023 at 04:31:07PM +0800, David Lin wrote:
> Remain on channel must be removed after authentication is done.
> Otherwise WMM setting for assoiation request will be removed.

Same comment as patch 2, this seems a fixup of commit 1, you should fix
that patch, not add a followup fixup commit.

Francesco

