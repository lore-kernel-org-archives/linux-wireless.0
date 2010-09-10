Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61969 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0IJWxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 18:53:37 -0400
Received: by iwn5 with SMTP id 5so2627038iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Sep 2010 15:53:36 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 10 Sep 2010 15:53:14 -0700
Message-ID: <AANLkTin98ReaNEHQ5+BzbrkNeFe6g-iKKpcXsHMOiass@mail.gmail.com>
Subject: Removing PCMCIA drivers from compat-wireless
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As per the summit discussion PCMCIA drivers tend to create an overhead
on maintenance of patches and since it seems we have no distributions
using the compat-wireless PCMCIA drivers we're going to drop it. If
you have objections, please speak up soon.

  Luis
