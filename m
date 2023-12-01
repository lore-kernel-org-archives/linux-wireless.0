Received: from mail11.truemail.it (mail11.truemail.it [IPv6:2001:4b7e:0:8::81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8121AF4;
	Fri,  1 Dec 2023 02:39:01 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id CC4D720645;
	Fri,  1 Dec 2023 11:38:59 +0100 (CET)
Date: Fri, 1 Dec 2023 11:38:58 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: David Lin <yu-hao.lin@nxp.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	briannorris@chromium.org, kvalo@kernel.org, francesco@dolcini.it,
	tsung-hsien.hsieh@nxp.com
Subject: Re: [PATCH v7 09/12] wifi: mwifiex: fixed the way to handle link
 lost.
Message-ID: <ZWm3whL69K/CJacH@francesco-nb.int.toradex.com>
References: <20231128083115.613235-1-yu-hao.lin@nxp.com>
 <20231128083115.613235-10-yu-hao.lin@nxp.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128083115.613235-10-yu-hao.lin@nxp.com>

On Tue, Nov 28, 2023 at 04:31:12PM +0800, David Lin wrote:
> If host mlme is enabled, event EVENT_LINK_LOST must be handled with
> sending deauthentication to upper layers.
> 
> Without this patch, if AP is leaving and station won't receive
> deauthentication from AP, station won't reconnect to AP again.

As commented on previous patches this should be done in the commit that
introduce the host mlme feature in the first place.

No fixup for a non committed patch, you should just avoid introducing the
bug in the first place.

Francesco

