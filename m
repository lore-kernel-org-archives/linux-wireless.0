Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58892 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933865AbeBMKu3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 05:50:29 -0500
Message-ID: <1518519026.2494.1.camel@sipsolutions.net> (sfid-20180213_115033_859816_FCE431F7)
Subject: Re: [PATCHv2 1/3] cfg80211: send ack_signal to user in probe client
 response
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Feb 2018 11:50:26 +0100
In-Reply-To: <5A82C15F.7060906@broadcom.com> (sfid-20180213_114347_243560_839A74AD)
References: <1518499986-10606-1-git-send-email-vnaralas@codeaurora.org>
         <5A82C15F.7060906@broadcom.com> (sfid-20180213_114347_243560_839A74AD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-02-13 at 11:43 +0100, Arend van Spriel wrote:
> On 2/13/2018 6:33 AM, Venkateswara Naralasetty wrote:
> > This patch provides support to get ack signal in probe client response
> > and in station info from user.
> 
> Hi Venkateswara,
> 
> In recent discussion [1] it was observed that a valid flag would not 
> really be needed as a signal level of zero could be used as valid 
> indication.

I don't think it matters much though, and physically 0 is a valid power
level, just practically we can't receive that high power :-)

johannes
