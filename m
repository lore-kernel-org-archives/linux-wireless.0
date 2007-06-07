Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:4926 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761785AbXFGSwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 14:52:04 -0400
Received: by py-out-1112.google.com with SMTP id a29so1006777pyi
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2007 11:52:03 -0700 (PDT)
Message-ID: <43e72e890706071152n2d687497va9449d330e2078b4@mail.gmail.com>
Date: Thu, 7 Jun 2007 14:52:03 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Stefano Brivio" <stefano.brivio@polimi.it>
Subject: Re: RFC: Regulatory info in mac80211
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070607091040.2b2f1d00@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <4665CCE7.5090409@lwfinger.net> <20070607091040.2b2f1d00@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/7/07, Stefano Brivio <stefano.brivio@polimi.it> wrote:
> On Tue, 05 Jun 2007 15:51:51 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> > 3. There should be some sort of checking to verify that the database has
> > not been hacked to modify transmission power, etc. in an illegal manner.
> > Obviously, no foolproof means of enforcing this does not exist; however,
> > we should prevent the crudest form of modifications.
>
> Why should this be enforced at all? What the Linux kernel has to do with
> enforcing legality?
>
> I see implementation of regulatory information in mac80211 as a convenient
> way in order to avoid issues for the end user. Those issues includes:
> 1) violating the regulatory domain compliance without noticing;
> 2) losing time in order to get around domain compliance checks, when
> this is done with perfect consciousness.

A bigger issue for users is support. As you very well know reverse
engineering is a long tedious process; we are essentially doomed to
reverse engineering  wireless drivers for some wireless devices where
regulatory compliance sits in the driver due to vendor fears on legal
liability. I'm not saying their fears are justified by any means I'm
just saying those fears do exist by some vendors and unfortunately we
suffer the consequences. So if we can do some sort of best effort,
perhaps we can steer some vendors to support us.

  Luis
