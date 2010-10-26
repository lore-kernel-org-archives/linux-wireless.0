Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:14213 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754990Ab0JZGjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 02:39:35 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0853565171
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 15:39:33 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: Access Channel Utilization
Date: Tue, 26 Oct 2010 15:39:34 +0900
Cc: "ath5k-devel" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <AANLkTinqLcr7OpQZijX70aVE_P8gpUp=6RkozzVZH5Fm@mail.gmail.com>
In-Reply-To: <AANLkTinqLcr7OpQZijX70aVE_P8gpUp=6RkozzVZH5Fm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010261539.34710.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue October 26 2010 15:24:42 Jonathan Guerin wrote:
> Hi,
> 
> I'm trying to access the phy-layer stats that were recently added to
> cfg80211 and nl80211. I'm using a modified version of iw as per this
> patch:
> https://dev.openwrt.org/browser/trunk/package/iw/patches/110-survey_phy_sta
> ts.patch
> 
> Unfortunately, the utilization stats don't appear to be getting sent
> back. I'm using ath5k as the underlying driver.

are you missing this patch?

"ath5k: Add channel time to survey data"
https://patchwork.kernel.org/patch/264831/

bruno
