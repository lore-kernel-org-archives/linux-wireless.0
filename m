Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaC1NDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:03:11 -0400
Message-ID: <1396011787.4175.21.camel@jlt4.sipsolutions.net> (sfid-20140328_140314_883461_BD2A878B)
Subject: Re: [PATCH v2 6/7] mac80211: remove old unused channel switching
 code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 14:03:07 +0100
In-Reply-To: <1395409941-26303-7-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145816_683118_EFF27856)
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409941-26303-1-git-send-email-michal.kazior@tieto.com>
	 <1395409941-26303-7-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140321_145816_683118_EFF27856)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-21 at 14:52 +0100, Michal Kazior wrote:
> ieee80211_vif_change_channel() has no uses

users?

> anymore. sdata->csa_radar_required is also removed
> because it is no longer used. Instead reservations
> take care of tracking whether an interface
> requires radar detection or not.

Why not kick it out in the patch that removes the users?

johannes

