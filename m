Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40838 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932180AbeEWKAi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 06:00:38 -0400
Message-ID: <1527069635.3759.17.camel@sipsolutions.net> (sfid-20180523_120117_661241_91AA3F09)
Subject: Re: [PATCH v3] iw: avgerage ack rssi changes for data frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Balaji Pothunoori <bpothuno@codeaurora.org>
Cc: bpothuno@qti.qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 23 May 2018 12:00:35 +0200
In-Reply-To: <1520493581-26708-1-git-send-email-bpothuno@codeaurora.org>
References: <1520493581-26708-1-git-send-email-bpothuno@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-03-08 at 12:49 +0530, Balaji Pothunoori wrote:
> This patch is to display the average ack rssi for data
> frames. "avg ack signal" field diplay limited by host based on
> firmware capablities.

This doesn't compile, please respin (and you could fix the "average"
typo in the subject)

johannes
