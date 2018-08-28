Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51206 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbeH1NQI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 09:16:08 -0400
Message-ID: <1535448313.5895.22.camel@sipsolutions.net> (sfid-20180828_112525_971701_CD3E42EE)
Subject: Re: [PATCH 1/3] cfg80211: Add support for 60GHz band channels 5 and
 6
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Date: Tue, 28 Aug 2018 11:25:13 +0200
In-Reply-To: <1534163582-9983-2-git-send-email-ailizaro@codeaurora.org>
References: <1534163582-9983-1-git-send-email-ailizaro@codeaurora.org>
         <1534163582-9983-2-git-send-email-ailizaro@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-08-13 at 15:33 +0300, Alexei Avshalom Lazar wrote:
> The current support in the 60GHz band is for channels 1-4.
> Add support for channels 5 and 6.
> This requires enlarging ieee80211_channel.center_freq from u16 to u32.

Applied.

johannes
