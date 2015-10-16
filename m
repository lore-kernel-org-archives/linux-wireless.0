Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:47242 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbbJPUqp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 16:46:45 -0400
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
	Jan Kaisrlik <kaisrja1@fel.cvut.cz>,
	wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, bernd.lehmann@volkswagen.de,
	jan-niklas.meier@volkswagen.de, s.sander@nordsys.de
Subject: Re: [RFC PATCH 1/2] cfg80211: Add support for ITS-G5 band (5.9 GHz)
In-Reply-To: <1445027060.2370.25.camel@sipsolutions.net>
References: <1444994885-21825-1-git-send-email-kaisrja1@fel.cvut.cz> <1444997197.2370.22.camel@sipsolutions.net> <87h9lqeplf.fsf@steelpick.2x.cz> <1445027060.2370.25.camel@sipsolutions.net>
Date: Fri, 16 Oct 2015 22:46:41 +0200
Message-ID: <87bnbyee32.fsf@steelpick.2x.cz> (sfid-20151016_224649_027648_C2A9F27F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 16 2015, Johannes Berg wrote:
> Hi,
>
>> I thought that the regdb is for unlicensed bands with unrestricted use.
>> The 5.9 GHz band is not licensed but it is restricted for ITS
>> applications. 
>
> It kind of is, at least the current one is.
>
>> In http://marc.info/?l=linux-wireless&m=140183393707445&w=2
>> Luis Rodriguez suggested that having a Kconfig option may be the way to
>> go, but we may misread what he was saying.
>
> I didn't really follow this.
>
>> I assume that if this band will be in regdb, it will be too easy to use
>> this band (e.g. by mistake) for non-ITS applications.
>
> Does the *regulatory* actually prohibit that anyway though?

Regulatory (ECC Decision (08)01) reads:

    ... decides ... that CEPT administrations shall designate the
    frequency sub-band 5875-5905 MHz on a non-exclusive basis for ITS
    traffic safety applications;

I'm not sure about the exact meaning of words "designate" and
"non-exclusive". If anyone can clarify that for me, I'd appreciate it. I
tend to understand that this band can be only used by ITS applications
(without license) or by other devices that have a proper license.

Thanks.
-Michal
