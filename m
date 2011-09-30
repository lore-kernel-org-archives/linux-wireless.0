Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46729 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111Ab1I3WL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 18:11:59 -0400
Received: by qadb15 with SMTP id b15so647549qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Sep 2011 15:11:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <400C43189542CE41BC0A5B252FC90136BC0CF45AE8@SJEXCHCCR02.corp.ad.broadcom.com>
References: <20110707002034.GA17885@broadcom.com> <20110824222801.GA5280@broadcom.com>
 <20110824225357.GA2224@suse.de> <20110824231746.GF5280@broadcom.com>
 <1314248569.5054.43.camel@jlt3.sipsolutions.net> <400C43189542CE41BC0A5B252FC90136BC0CF45AE8@SJEXCHCCR02.corp.ad.broadcom.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 30 Sep 2011 15:11:39 -0700
Message-ID: <CAB=NE6Uvq0=w7i-Wt_ooeS5_3-8+CbQAmtFoMJo+_43F71jAMQ@mail.gmail.com> (sfid-20111001_001215_302931_B63661BD)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
To: Arend Van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Greg KH <gregkh@suse.de>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 30, 2011 at 2:54 PM, Arend Van Spriel <arend@broadcom.com> wrote:
>> From: Johannes Berg [mailto:johannes@sipsolutions.net]
>> Sent: donderdag 25 augustus 2011 7:03
>>
>> > +#define LOCK(wl)   spin_lock_bh(&(wl)->lock)
>>
>> No way ...
>>
>
> Hi Johannes,
>
> Your comment is a bit open for interpretation (or not ;-) ). Could you elaborate on this one?

Dude, just kill the define.

  Luis
