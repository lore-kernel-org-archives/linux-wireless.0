Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757050AbZBRVgL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 16:36:11 -0500
Subject: Re: Mysterious IWLWIFI_SPECTRUM_MEASUREMENT config
From: reinette chatre <reinette.chatre@intel.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87d4df1wfz.fsf@litku.valot.fi>
References: <87d4df1wfz.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 13:40:25 -0800
Message-Id: <1234993225.12483.41.camel@rc-desk> (sfid-20090218_223621_256173_C8C009E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-02-18 at 09:33 -0800, Kalle Valo wrote:
> I was doing my usual practise of recompiling my kernel and again I was
> asked this question:
> 
> Enable Spectrum Measurement in iwlagn driver
> (IWLWIFI_SPECTRUM_MEASUREMENT) [N/y/?] (NEW)
> 
> Ok, so I chose '?' and got this:
> 
> "This option will enable spectrum measurement for the iwlagn driver."
> 
> Not a very helpful message. I have few kind requests:
> 
> 1) Please write a proper description for the option.
Will do.

> 2) Recommend a proper default value: "If you don't have a clue what
>    this is, choose N".

These are 802.11h measurements ... so typical users may not be
interested. We'll make this a default N.

> 
> 3) Please consider even removing the option. Is it really needed?
> 

Some users may want this information so we'll keep it as an option for
now. 

Reinette

