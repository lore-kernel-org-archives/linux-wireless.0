Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:45287 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbYGJMZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 08:25:08 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1036485yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2008 05:25:07 -0700 (PDT)
Message-ID: <1ba2fa240807100525u3697e2f2rcde945a765412eb5@mail.gmail.com> (sfid-20080710_142513_538608_63FD367C)
Date: Thu, 10 Jul 2008 15:25:07 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Bruno Randolf" <br1@einfach.org>
Subject: Re: [PATCH 1/1] iwlwif: remove compilation warnings iwl_add_radiotap
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <200807101342.36920.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215689322-25017-1-git-send-email-tomas.winkler@intel.com>
	 <200807101342.36920.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 10, 2008 at 2:42 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Thursday 10 July 2008 13:28:42 Tomas Winkler wrote:
>> Use directly put_unaligned_leX instead of put_unaligned(cpu_to_leX
>>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>
> hi!
>
> what about using the generic function to add the radiotap header from
> mac80211? it should be flexible enough to handle all devices by now.
>
Why not go ahead.
Tomas
