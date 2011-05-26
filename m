Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62954 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab1EZGWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 02:22:22 -0400
Received: by ewy4 with SMTP id 4so149573ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2011 23:22:21 -0700 (PDT)
From: Stevie Trujillo <stevie.trujillo@gmail.com>
To: wwguy <wey-yi.w.guy@intel.com>
Subject: Re: iwlagn: is tx_power_device_lmt a regulatory limit or a hardware limit?
Date: Thu, 26 May 2011 08:22:18 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <201105251813.36804.stevie.trujillo@gmail.com> <201105252154.06204.stevie.trujillo@gmail.com> <1306376938.20732.2.camel@wwguy-ubuntu>
In-Reply-To: <1306376938.20732.2.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201105260822.18316.stevie.trujillo@gmail.com> (sfid-20110526_082227_572633_3749A207)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 May 2011 04:28:58 wwguy wrote:
> On Wed, 2011-05-25 at 12:54 -0700, Stevie Trujillo wrote:
> > On Wednesday 25 May 2011 21:42:40 wwguy wrote:
> > > On Wed, 2011-05-25 at 09:13 -0700, Stevie Trujillo wrote:
> > > > Hello,
> > > > 
> > > > I have a "Intel(R) Centrino(R) 1030 BGN" card. tx_power_device_lmt is
> > > > 15 and I was wondering if the card could do more than that.
> > > 
> > > the card should not and will not do more than what required by
> > > regulatory
> > 
> > I'm allowed to do 20dBm here and was wondering if I could make the card
> > do that.
> 
> the tx power in Intel WiFi device is regulated by uCode to make sure we
> are within regulatory limits. What country you are in?

Norway

Thanks
Stevie
