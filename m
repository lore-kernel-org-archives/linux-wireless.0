Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:35848 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab3GYW4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jul 2013 18:56:46 -0400
Received: by mail-ve0-f180.google.com with SMTP id pa12so864559veb.11
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jul 2013 15:56:45 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 26 Jul 2013 06:56:45 +0800
Message-ID: <CAEFj98425059MUkWpvyaq3USheh91F2HbHN7vACQSwAG-rU+NQ@mail.gmail.com> (sfid-20130726_005705_601389_EBCEB781)
Subject: Re: authsae, 'ath9k nohwcrypt=1' & AR9100
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to solve the problem for the open mesh to avoid older
chipset filters out certain frame required for mesh. Without this
patch, I am not too sure whether the secure mesh will work.

---
Chun-Yeow
