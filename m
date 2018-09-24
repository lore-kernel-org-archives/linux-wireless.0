Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54264 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727497AbeIXPs7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 11:48:59 -0400
Subject: Re: [PATCH] mt76: report firmware version using ethtool
To: Davide Caratti <dcaratti@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <cda71b037871304f80558ff3391cef709c317433.1537445946.git.dcaratti@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <ee8f8e32-3b64-df25-df9a-d4b8409e8803@nbd.name> (sfid-20180924_114749_580066_7DD009C2)
Date: Mon, 24 Sep 2018 11:47:44 +0200
MIME-Version: 1.0
In-Reply-To: <cda71b037871304f80558ff3391cef709c317433.1537445946.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-20 14:30, Davide Caratti wrote:
> print fw_ver and build_ver members of struct mt76x02_fw_header, similarly
> to what appears in the output of 'dmesg' when the MCU firmware is loaded.
> 
> Reported-by: Sid Hayn <sidhayn@gmail.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Merged, thanks.

- Felix
