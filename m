Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:53801 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415AbYFSVgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 17:36:10 -0400
Received: by py-out-1112.google.com with SMTP id p76so438522pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 14:36:09 -0700 (PDT)
Message-ID: <1ba2fa240806191436r3fee6eecoe5dfbbd738ff0a0f@mail.gmail.com> (sfid-20080619_233629_085381_0CA49E0A)
Date: Fri, 20 Jun 2008 00:36:09 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [PATCH 1/1] mac80211: fix tx fragmenation
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910806191431r96f2ab8vefac8321d26d846e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213909810-23170-1-git-send-email-tomas.winkler@intel.com>
	 <69e28c910806191431r96f2ab8vefac8321d26d846e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 20, 2008 at 12:31 AM, Stefanik G=E1bor
<netrolller.3d@gmail.com> wrote:
> On Thu, Jun 19, 2008 at 11:10 PM, Tomas Winkler <tomas.winkler@intel.=
com> wrote:
>> +               memcpy(frag->cb, first->cb, sizef(frag->cb));
>
> Shouldn't that be sizeof(frag->cb)? "Sizef" doesn't even compile.

going sleep now :)
Tomas
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
