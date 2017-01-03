Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43230 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756457AbdACF2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 00:28:43 -0500
Date: Tue, 3 Jan 2017 10:58:27 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: [1/2] ath10k: add accounting for the extended peer statistics
Message-ID: <20170103052827.GA8204@atheros-ThinkPad-T61> (sfid-20170103_062847_223234_05673BCB)
References: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
 <c3f99e7634384475b475b97ff46bec76@euamsexm01a.eu.qualcomm.com>
 <CAAd0S9DcCM9XQOihZx1sVf_1=S3VvDye4k1gEMgWEmNWDaBk5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAd0S9DcCM9XQOihZx1sVf_1=S3VvDye4k1gEMgWEmNWDaBk5Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian / Kalle,

On Fri, Dec 30, 2016 at 03:35:10PM +0100, Christian Lamparter wrote:
> On Thu, Dec 29, 2016 at 3:11 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> > Christian Lamparter <chunkeey@googlemail.com> wrote:
> >> The 10.4 firmware adds extended peer information to the
> >> firmware's statistics payload. This additional info is
> >> stored as a separate data field and the elements are
> >> stored in their own "peers_extd" list.
> >>
> >> These elements can pile up in the same way as the peer
> >> information elements. This is because the
> >> ath10k_wmi_10_4_op_pull_fw_stats() function tries to
> >> pull the same amount (num_peer_stats) for every statistic
> >> data unit.
> >>
> >> Fixes: 4a49ae94a448faa ("ath10k: fix 10.4 extended peer stats update")
> >> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> >
> > My understanding is that I should skip this patch 1. Please let me know if
> > I misunderstood. But I'm still plannning to apply patch 2.
> 
> I added Mohammed (I hope, he can reply to the open question when he
> returns), Since I'm not sure what he wants or not.
> 
> As far as I'm aware, the "extended" boolean serves no purpose
> because it was only used in once place in debugfs_sta which was
> removed in the patch. ( "ath10k_sta_update_stats_rx_duration"
> and "ath10k_sta_update_extd_stats_rx_duration" have been unified).

[shafi] We will wait for Kalle to review from the de-ferred stage
and get his opinion as well(regarding the design change).
I have no concerns as long this does not changes the existing behaviour.
thank you !

regards,
shafi
