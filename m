Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38023 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832AbaCSO0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:26:50 -0400
Message-ID: <1395239207.4142.25.camel@jlt4.sipsolutions.net> (sfid-20140319_152653_764157_3E371E50)
Subject: Re: [PATCH 3/3] cfg80211: slightly clean up of
 cfg80211_sme_connect()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Mar 2014 15:26:47 +0100
In-Reply-To: <2765d477f16c3ade4361cbbbc170f7343b433b23.1395219362.git.gamerh2o@gmail.com> (sfid-20140319_100453_080515_4AFE4F5F)
References: <195ce75d7f8c2db484ccea7453147289e880c148.1395219362.git.gamerh2o@gmail.com>
	 <2765d477f16c3ade4361cbbbc170f7343b433b23.1395219362.git.gamerh2o@gmail.com>
	 (sfid-20140319_100453_080515_4AFE4F5F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-19 at 17:04 +0800, Zhao, Gang wrote:

> -	wdev->conn->params.ssid = wdev->ssid;
> +	wdev->conn->params.ssid = connect->ssid;

I'm pretty sure this is wrong since one is a pointer and the other an
array.

johannes

