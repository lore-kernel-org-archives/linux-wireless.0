Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:36423 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413AbbLANId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 08:08:33 -0500
Received: by lfs39 with SMTP id 39so6912830lfs.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2015 05:08:31 -0800 (PST)
Subject: Re: [PATCH] ath6kl: Use vmalloc to allocate ar->fw for api1 method
To: Brent Taylor <motobud@gmail.com>, kvalo@qca.qualcomm.com
References: <1448948470-31111-1-git-send-email-motobud@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ath6kl@lists.infradead.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <565D9BCD.6020105@cogentembedded.com> (sfid-20151201_141500_347604_545B1E0E)
Date: Tue, 1 Dec 2015 16:08:29 +0300
MIME-Version: 1.0
In-Reply-To: <1448948470-31111-1-git-send-email-motobud@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 12/1/2015 8:41 AM, Brent Taylor wrote:

> Since commit 8437754c83351d6213c1a47ff029c1126d6042a7,

    The scripts/checkpatch.pl now enforces certain format of the commit citing.

> ar->fw is expected to be pointing to memory allocated by vmalloc.  If the api1 method (via ath6kl_fetch_fw_api1) is used to allocate memory for ar->fw, then kmemdup is used.  This patch checks if the firmware being loaded is the 'fw' image, then use vmalloc, otherwise use kmalloc.

    This script also checks for unwrapped changelogs. Please run your patches 
thru it before posting.

> Signed-off-by: Brent Taylor <motobud@gmail.com>
[...]

MBR, Sergei

