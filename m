Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:14568 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbYIYTni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 15:43:38 -0400
Received: by nf-out-0910.google.com with SMTP id d3so241928nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 12:43:36 -0700 (PDT)
Message-ID: <f488382f0809251243x472ff579n8ada22e8f7110aae@mail.gmail.com> (sfid-20080925_214342_447143_1B3D8115)
Date: Thu, 25 Sep 2008 12:43:36 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Tomas Winkler" <tomas.winkler@intel.com>
Subject: Re: [RFC V3] mac80211: re-enable aggregation on 2.6.27
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1222371297-24498-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222371297-24498-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 12:34 PM, Tomas Winkler <tomas.winkler@intel.com> wrote:
> Re-enable aggregation by addressing skb->cb overwrites
> after insertion into the qdisc. Aggregation was disabled
> after the new TX multiqueue changes were introduced. Instead
> of relying on the skb->cb we use two flags on the skb.
>

I seem to recall that implementing aggregation was causing issues with
ath9k among others (in particular, ath9k was getting slow throughput).
How's throughput with this version of the aggregation patch?

- Steven
