Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37065 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbeIXQ0X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 12:26:23 -0400
Received: by mail-ed1-f66.google.com with SMTP id a20-v6so15798932edd.4
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2018 03:25:00 -0700 (PDT)
Date: Mon, 24 Sep 2018 13:24:54 +0300
From: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH v3] brcmsmac: AP mode: update beacon when TIM changes
Message-ID: <20180924132454.1703045f@manjaro> (sfid-20180924_122503_843951_5E29CBA9)
In-Reply-To: <1d03765b-2643-1c86-f0e7-b42664252f08@broadcom.com>
References: <20180911172618.13049-1-alimjalnasrawy@gmail.com>
        <20180923095425.10292-1-alimjalnasrawy@gmail.com>
        <1d03765b-2643-1c86-f0e7-b42664252f08@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 24 Sep 2018 10:15:49 +0200
Arend van Spriel <arend.vanspriel@broadcom.com> wrote:

> On 9/23/2018 11:54 AM, Ali MJ Al-Nasrawy wrote:
> > Beacons are not updated to reflect TIM changes. This is not
> > compliant with power-saving client stations as the beacons do not
> > have valid TIM and can cause the network to stall at random
> > occasions with highly variable latencies. Fix it by updating beacon
> > templates on mac80211 set_tim callback.
> >
> > Addresses an issue described in:
> > https://marc.info/?i=20180911163534.21312d08%20()%20manjaro
> >
> > Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
> > ---  
> 
> Missing 'v1 -> v2' in this changelog.

Sorry, missed that...

v1 -> v2:
	-removed FIXME comment
	-removed blank line before 'vif' member declaration
