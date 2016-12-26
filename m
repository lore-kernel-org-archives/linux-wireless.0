Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:36601 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbcLZVt7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Dec 2016 16:49:59 -0500
Received: by mail-pg0-f43.google.com with SMTP id f188so137789223pgc.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Dec 2016 13:49:58 -0800 (PST)
Subject: Re: [PATCH] mac80211: Fix addition of mesh configuration element
To: Ilan Peer <ilan.peer@intel.com>, johannes@sipsolutions.net
References: <1482769056-28577-1-git-send-email-ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <66eceab9-7192-72a6-8512-9329d0d92479@gmail.com> (sfid-20161226_225003_080863_DCE7B42F)
Date: Tue, 27 Dec 2016 06:49:55 +0900
MIME-Version: 1.0
In-Reply-To: <1482769056-28577-1-git-send-email-ilan.peer@intel.com>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年12月27日 01:17, Ilan Peer wrote:
> The code was setting the capabilities byte to zero,
> after it was already properly set previously. Fix it.
>
> The bug was found while debugging hwsim mesh tests failures
> that happened in commit 76f43b4 (mac80211: Remove invalid flag
> operations in mesh TSF synchronization).

Thanks!

Reviewed-by: Masashi Honma <masashi.honma@gmail.com>
