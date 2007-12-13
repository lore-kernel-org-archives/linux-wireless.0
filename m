Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:64257 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933900AbXLMXBQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 18:01:16 -0500
Message-ID: <4761B9C0.3080309@jooz.net> (sfid-20071213_230129_548257_6C3D5FA5)
Date: Fri, 14 Dec 2007 00:01:20 +0100
From: Bjorge Dijkstra <bjd@jooz.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: status wireless extensions API for new drivers
References: <4761A108.2080005@jooz.net> <20071213213118.GE3083@tuxdriver.com> <4761AD18.8000004@jooz.net> <20071213221323.GF3083@tuxdriver.com>
In-Reply-To: <20071213221323.GF3083@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> BTW, how is your patchset looking?  If you want it to be in 2.6.25
> then you need to post it soon.
> 

It's currently in the form of a seperate self supporting package based
on an older kernel. So that probably needs a little bit of work to get
it rebased on current kernel. It's not a must for me to get it in 2.6.25
though, so if we miss it that's not a problem.

BTW, when is the approx. deadline for 2.6.25?

> FWIW, as long as you have just enough WEXT support to get it to work
> with open networks I think that would be enough to get a patch merged.
> Having experimented a bit earlier with your patchset, I suspect you
> can probably support WEP and maybe more by now...

Yes, WEP, WPA and WPA2 all should work fine. I'm using it everyday on a
WPA2 network with no issues. I don't have a wired connection here, so I
depend on it working for me :)

> 
> So, when will we see your patches?
> 

I'll try get something out during the weekend.

> Thanks,
> 
> John

regards,
Bjorge

