Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:31088 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYDAFxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 01:53:31 -0400
Received: by py-out-1112.google.com with SMTP id u52so2831273pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 22:53:28 -0700 (PDT)
Message-ID: <1ba2fa240803312253l4595ce43ya3a6812ceb216f12@mail.gmail.com> (sfid-20080401_065333_827715_A2F6F9FB)
Date: Tue, 1 Apr 2008 08:53:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: drago01 <drago01@gmail.com>
Subject: Re: [ipw3945-devel] dynamic wep with mulitple keys
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <f6ca9fed0803311237w1b714034w8ba3cfd56aec9686@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0803311237w1b714034w8ba3cfd56aec9686@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/31/08, drago01 <drago01@gmail.com> wrote:
> Hello,
>
> I noticed that I can connect to some dynamic wep APs fine using
> iwl3945 and with other it does not work, while ipw3945 work with all
> of them.
> Both driver associate fine but iwl3945 never gets an ip from dhcp.
> I checked with iwlist key and it seems that this APs are using only
> one key with iwl3945 but two with ipw3945.
> The APs that work (I recognize them by BSSID) are using only one key
> with both drivers.
> Does this mean that mac80211/iwl3945 for some reason drops one key or
> never sets it?  (broadcast key?)
> Any idea how to get more infos to debug this? (Can attach both iwlist
> key outputs if this is needed).

Currently iwl uses cryptom management provided by mac80211, we are
preparing patches for using of HW acceleration till now you must look
for
problems mac80211.
Some log prints will be useful to debug it anyway.

Tomas


> -------------------------------------------------------------------------
> Check out the new SourceForge.net Marketplace.
> It's the best place to buy or sell services for
> just about anything Open Source.
> http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
