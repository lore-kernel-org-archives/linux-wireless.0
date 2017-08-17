Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:34001 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753297AbdHQWyi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 18:54:38 -0400
Received: by mail-pg0-f47.google.com with SMTP id u185so51693072pgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Aug 2017 15:54:38 -0700 (PDT)
Date: Fri, 18 Aug 2017 08:54:43 +1000
From: Barry Day <briselec@gmail.com>
To: Fredrik Gustafsson <iveqy@iveqy.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iw not finding physical interface
Message-ID: <20170817225440.GA27197@testbox> (sfid-20170818_005442_288201_DAFDE4D4)
References: <20170817111804.GE24362@paksenarrion.iveqy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170817111804.GE24362@paksenarrion.iveqy.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Try changing the driver setting in /etc/hostapd.conf to wext
