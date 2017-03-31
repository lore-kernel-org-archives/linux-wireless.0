Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42486 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753049AbdCaGcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 02:32:04 -0400
Message-ID: <1490941921.24283.2.camel@sipsolutions.net> (sfid-20170331_083246_558883_A8171069)
Subject: Re: [PATCH 1/2] cfg80211: Use a structure to pass connect response
 params
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
Date: Fri, 31 Mar 2017 08:32:01 +0200
In-Reply-To: <1490908954-5412-1-git-send-email-jouni@qca.qualcomm.com>
References: <1490908954-5412-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-31 at 00:22 +0300, Jouni Malinen wrote:
> From: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
> 
> Currently the connect event from driver takes all the connection
> response parameters as arguments. With support for new features these
> response parameters can grow. Use a structure to pass these
> parameters
> rather than passing them as function arguments.

Applied, I added the new things to the documentation.

johannes
