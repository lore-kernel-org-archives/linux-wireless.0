Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45380 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab1FEJUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 05:20:52 -0400
Received: by iwn34 with SMTP id 34so2422901iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Jun 2011 02:20:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DEB3FF3.8090904@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-44-git-send-email-rvossen@broadcom.com> <BANLkTin1hT2WT40_uozZvtX-PH5aZHqfZg@mail.gmail.com>
 <4DE90DCE.6060207@broadcom.com> <BANLkTimQacOURw4wQzkyNizksZZj=nhvfQ@mail.gmail.com>
 <4DEB3FF3.8090904@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 5 Jun 2011 19:20:32 +1000
Message-ID: <BANLkTi=HrP5pSi0t-18N2yGpBueeL2qMSg@mail.gmail.com> (sfid-20110605_112102_998321_3772F68E)
Subject: Re: [PATCH 44/83] staging: brcm80211: replaced typedef si_t with
 struct si_pub
To: Roland Vossen <rvossen@broadcom.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 5, 2011 at 18:36, Roland Vossen <rvossen@broadcom.com> wrote:
> Hi Julian,
>
>> On Sat, Jun 4, 2011 at 02:37, Roland Vossen<rvossen@broadcom.com>  wrote:
>>>
>>> Hello Julian,
>>>
>>> the structure definition itself is already in a header file (aiutils.h).
>>> Probably you are referring to the forward declaration used in the patch?
>>
>> Exactly, it probably shouldn't be here as the header file that
>> includes the structure should arguably already be included.
>
> I am afraid I have to disagree with you, for the reason that by including
> the header file you introduce unnecessary coupling. Let me elaborate. If a
> .c file does not need to know the contents of a struct, but it only needs to
> know that a pointer to an opaque struct, then one should not provide the C
> file with knowledge on the internals of the struct (hence not include the .h
> file).

Fair enough. I guess I just don't like void pointers.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
