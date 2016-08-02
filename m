Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189AbcHBGi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 02:38:26 -0400
Date: Tue, 2 Aug 2016 08:34:19 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Daniel Wagner <daniel.wagner@bmw-carit.de>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Daniel Wagner <wagi@monom.org>,
	Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	linux-input@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
Message-ID: <20160802063419.GG3296@wotan.suse.de> (sfid-20160802_083844_139359_D69AF09D)
References: <1469692512-16863-8-git-send-email-wagi@monom.org>
 <20160728183343.GD16852@dtor-ws>
 <20160728190151.GV13516@tuxbot>
 <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de>
 <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
 <20160730165817.GQ3296@wotan.suse.de>
 <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
 <37a3cd66-262e-ffbe-ea7a-a6d5b1ca1c8b@bmw-carit.de>
 <20160801194408.GZ3296@wotan.suse.de>
 <0f9350fa-e8b5-9d64-b2d3-afda5e5f6bbf@bmw-carit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0f9350fa-e8b5-9d64-b2d3-afda5e5f6bbf@bmw-carit.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 02, 2016 at 07:49:19AM +0200, Daniel Wagner wrote:
> >The sysdata API's main goal rather is to provide a flexible API first,
> >compartamentalizing the usermode helper was secondary. But now it seems
> >I may just also add devm support too to help simplify code further.
> 
> I missed the point that you plan to add usermode helper support to
> the sysdata API.

I had no such plans, when I have asked folks so far about "hey are you
really in need for it, OK what for? " and "what extended uses do you
envision?" so I far I have not gotten any replies at all. So -- instead
sysdata currently ignores it.

  Luis
