Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:35287 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbbHMRlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 13:41:04 -0400
Received: by obbop1 with SMTP id op1so42883084obb.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2015 10:41:03 -0700 (PDT)
Subject: Re: b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 12, Type 11 (AC),
 Revision 1)
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
References: <55CCD13C.7010006@redhat.com>
 <CACna6rxm7MbEhnke91G8M+wPNfzCo6RkCm2OdyKrEshd1FN_EA@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sean Richards <ft86drifter@cox.net>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55CCD679.9070409@lwfinger.net> (sfid-20150813_194109_719061_5856540F)
Date: Thu, 13 Aug 2015 12:40:09 -0500
MIME-Version: 1.0
In-Reply-To: <CACna6rxm7MbEhnke91G8M+wPNfzCo6RkCm2OdyKrEshd1FN_EA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/13/2015 12:30 PM, Rafał Miłecki wrote:
> On 13 August 2015 at 19:17, Hans de Goede <hdegoede@redhat.com> wrote:
>> I'm trying to help a Fedora user to get his wifi to work on a
>> Lenovo Yoga 3 14, ad currently we are stuck with the
>> b43 driving giving the error from $subject,
>> is there anyone who can help with this ?
>
> Well, the $subject says everything. There is noone really working on
> it right now.

For b43 to support that device would require a major reverse-engineering effort 
that none of us are willing to do, at least at this time. There was an E-mail 
exchange (http://marc.info/?l=linux-wireless&m=143947632524690&w=2) with Sean 
yesterday about this issue. To summarize, this device needs to use the Broadcom 
hybrid driver wl with the non-GPL kernel taint and all.

Larry


