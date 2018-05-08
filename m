Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932465AbeEHOxX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 10:53:23 -0400
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 0926160386
        for <linux-wireless@vger.kernel.org>; Tue,  8 May 2018 14:53:22 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 08 May 2018 07:53:22 -0700
From: Jeff Johnson <jjohnson@codeaurora.org>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: remove variables which set but not used
In-Reply-To: <4abfd7695766fe156187a12c00320a55@codeaurora.org>
References: <20180507093948.GA7905@blackstone>
 <4abfd7695766fe156187a12c00320a55@codeaurora.org>
Message-ID: <4abd25ee9bfcb0a41c5c4cda6e19972b@codeaurora.org> (sfid-20180508_165328_716891_863DC21C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-07 02:39, Kenneth Lu wrote:
> Variable buf_len and num_vdev_stats are bging assigned but never read.

typo: bging => being
