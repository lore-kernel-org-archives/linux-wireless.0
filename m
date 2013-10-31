Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab3JaOnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 10:43:19 -0400
Message-ID: <1383230593.14302.1.camel@jlt4.sipsolutions.net> (sfid-20131031_154322_036090_3BAB0814)
Subject: Re: [PATCH] cfg80211: Introduce critical protocol indication for
 p2p connection.
From: Johannes Berg <johannes@sipsolutions.net>
To: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Thu, 31 Oct 2013 15:43:13 +0100
In-Reply-To: <1383230452-12608-1-git-send-email-usdutt@qti.qualcomm.com> (sfid-20131031_154108_037102_6F3E1A6D)
References: <1383230452-12608-1-git-send-email-usdutt@qti.qualcomm.com>
	 (sfid-20131031_154108_037102_6F3E1A6D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-31 at 20:10 +0530, Sunil Dutt Undekari wrote:
> A reliable P2P connection needs to avoid any offload off channel
> operations triggered by the host driver.

That's not what the critical protocol stuff was designed for, so no.

johannes

