Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55170 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753717AbeBLSkh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Feb 2018 13:40:37 -0500
Subject: Re: [PATCH] ath9k: fix DFS detector synchronization
To: Timothy Redaelli <tredaelli@redhat.com>,
        linux-wireless@vger.kernel.org
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
References: <c967cb589b7d71a17afc29f3c634f961ef6820dd.1518090407.git.tredaelli@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <a05983e5-5772-e795-d804-142fb65e7cd5@nbd.name> (sfid-20180212_194041_118244_4D1B940A)
Date: Mon, 12 Feb 2018 19:40:34 +0100
MIME-Version: 1.0
In-Reply-To: <c967cb589b7d71a17afc29f3c634f961ef6820dd.1518090407.git.tredaelli@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-02-08 12:46, Timothy Redaelli wrote:
> The code currently syncronize the DFS region only if curchan != 0, but hostapd
> launch DFS before the channel is set and so set_dfs_domain is never executed.
> 
> CC: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Timothy Redaelli <tredaelli@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
