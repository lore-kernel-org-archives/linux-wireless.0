Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3786 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab1LIRiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 12:38:18 -0500
Message-ID: <4EE2476A.3050107@broadcom.com> (sfid-20111209_183821_259127_91A5350D)
Date: Fri, 9 Dec 2011 18:37:46 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcma usage in isr context
References: <4ED77C85.1050705@broadcom.com>
 <CACna6rznu8d1BjG0EWjP1VRCPdYAGJv1q+fi1X+XF_Bf-Cx+Mg@mail.gmail.com>
 <4EDCE2CC.3060500@broadcom.com>
 <CACna6rwVRrm8YgvoYAmswru8nHXgytuiDRO2F2TQVZyxnfaV9w@mail.gmail.com>
 <4EDF71C6.9050800@broadcom.com>
 <CACna6rzQqJ-jeuoYMiyYBTt7tXzYV-noCg_kCmOynBrFBnLn2A@mail.gmail.com>
In-Reply-To: <CACna6rzQqJ-jeuoYMiyYBTt7tXzYV-noCg_kCmOynBrFBnLn2A@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2011 04:06 PM, Rafał Miłecki wrote:
> W dniu 7 grudnia 2011 15:01 użytkownik Arend van Spriel
> <arend@broadcom.com> napisał:
>> I also intend to do some suspend/resume
>> testing. I believe there was some issue mentioned on wireless mailing
>> list with bcma/b43.
> 
> That would be great. I don't have any notebook to use with Broadcom
> card, that's why suspend&resume isn't implemented. I do all
> development with my PC. In the notebook wireless card is integrated
> with the motherboard.
> 

Hi Rafał,

Your patch works so I dropped my temp solution using spinlock. Regarding
suspend/resume it works for suspend-to-ram. The connection is not
reestablished, but that is probably because I have it not configured in
NetworkManager to automatically connect.

Gr. AvS

