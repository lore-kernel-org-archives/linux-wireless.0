Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:42687 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbZJUORX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 10:17:23 -0400
Received: by fg-out-1718.google.com with SMTP id d23so2618154fga.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2009 07:17:26 -0700 (PDT)
From: Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath9k-devel] Test for N-mode from userspace?
Date: Wed, 21 Oct 2009 19:47:17 +0530
Cc: austinxxh-ath9k@yahoo.com, ath9k-devel@lists.ath9k.org,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200910202112.30660.kunal.gangakhedkar@gmail.com> <200910211107.58111.kunal.gangakhedkar@gmail.com> <43e72e890910202349g474a79fehf3fcc4d66837e70b@mail.gmail.com>
In-Reply-To: <43e72e890910202349g474a79fehf3fcc4d66837e70b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200910211947.17860.kunal.gangakhedkar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 Oct 2009 12:19:44 pm Luis R. Rodriguez wrote:
> On Wed, Oct 21, 2009 at 2:37 PM, Kunal Gangakhedkar
>
> <kunal.gangakhedkar@gmail.com> wrote:
> > On Wednesday 21 Oct 2009 4:50:18 am Luis R. Rodriguez wrote:
> >> On Wed, Oct 21, 2009 at 2:28 AM, xxiao <austinxxh-ath9k@yahoo.com> wrote:
> >> > interesting, why is MCS range just 0-7, which means no HT?
> >>
> >> MCS 1-7 is for single stream devices.
> >>
> >> http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n
> >
> > So, does this mean that I can use N-mode on this device?
>
> Yes, MCS 7 is your highest rate on your card.
>

Great.. that is really sweet :)

Thanks,
Kunal
