Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40011 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0LVTUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 14:20:19 -0500
Received: by qyj19 with SMTP id 19so6830654qyj.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 11:20:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293045092-12483-1-git-send-email-linville@tuxdriver.com>
References: <1293045092-12483-1-git-send-email-linville@tuxdriver.com>
Date: Wed, 22 Dec 2010 20:20:18 +0100
Message-ID: <AANLkTikJcCWph2OCp+eaEsdKDXT8Q374KFp=13zX+Rro@mail.gmail.com>
Subject: Re: [PATCH 0/3] b43: Is this series still valid??
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/22 John W. Linville <linville@tuxdriver.com>:
> I found this old series pending in my queue from months ago.  I sat on
> them because they had some discussion and never got reposted.
>
> Looking closer, the discussion never amounted to a NAK.  So, I tried
> applying them, and they applied with only minor massaging.
>
> So, are these still valid?
>
> Let me know...

The way we call init in one of patches may be incorrect, I'm not sure
if we still need to keep b_width (from other patch). I think it'll be
better to ignore that patches for now.

-- 
Rafał
