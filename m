Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:14620 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYJFPVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 11:21:08 -0400
Received: by yx-out-2324.google.com with SMTP id 8so427269yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 08:21:07 -0700 (PDT)
Message-ID: <eb3ff54b0810060821l75658922s6ed43ea763c448b8@mail.gmail.com> (sfid-20081006_172113_125952_C2436DCD)
Date: Mon, 6 Oct 2008 17:21:07 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH 2/2] iwlwifi: fix compliation warning in iwl-scan.c when CONFIG_IWLWIFI_DEBUG is not set.
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	yi.zhu@intel.com
In-Reply-To: <1ba2fa240810060742y7d0d4d24w984fe55be178e6d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0810060659n7d93a9fcla1301fa68a8a23a5@mail.gmail.com>
	 <1ba2fa240810060742y7d0d4d24w984fe55be178e6d1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
Yes, now I found you are right;
see:
http://marc.info/?l=linux-wireless&m=122282784617899&w=2


Regards,
Rami Rosen

On Mon, Oct 6, 2008 at 4:42 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Mon, Oct 6, 2008 at 3:59 PM, Rami Rosen <ramirose@gmail.com> wrote:
>> When CONFIG_IWLWIFI_DEBUG is not set and CONFIG_IWLWIFI is set,
>> we get this compilation warning:
>> wireless-next-2.6/drivers/net/wireless/iwlwifi/iwl-scan.c:92: warning:
>> 'iwl_escape_essid' defined but not used
>>
>> This patch (against wireless-next-2.6 tree) fixes it.
>>
> I believe there is queued patch that removes this code completely
> Tomas
>
