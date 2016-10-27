Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39608 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935657AbcJ0OAb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 10:00:31 -0400
Message-ID: <1477576826.4534.19.camel@sipsolutions.net> (sfid-20161027_160131_419201_0FF80E57)
Subject: Re: [PATCH v2] cfg80211: Add support to update connection parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@qti.qualcomm.com>
Date: Thu, 27 Oct 2016 16:00:26 +0200
In-Reply-To: <1477576271-12696-1-git-send-email-jouni@qca.qualcomm.com>
References: <1477576271-12696-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-10-27 at 16:51 +0300, Jouni Malinen wrote:
> From: vamsi krishna <vamsin@qti.qualcomm.com>
> 
> Add functionality to update the connection parameters when in
> connected
> state, so that driver/firmware uses the updated parameters for
> subsequent roaming. This is for drivers that support internal BSS
> selection and roaming. The new command does not change the current
> association state, i.e., it can be used to update IE contents for
> future
> (re)associations without causing an immediate disassociation or
> reassociation with the current BSS.
> 
> [...]

applied.

johannes
