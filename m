Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:51153 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZJTOKC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 10:10:02 -0400
Received: by ywh40 with SMTP id 40so3523399ywh.33
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 07:10:06 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 Oct 2009 10:10:06 -0400
Message-ID: <86201b3f0910200710u36557bf8uf5bc014b32b14d33@mail.gmail.com>
Subject: Rate information in ad-hoc and mesh mode
From: Charles Gordon <digigordo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I notice that the ieee80211_ioctl_giwrate function in wext.c only
returns rate information for stations associated to an AP.  It does
not return rate information for stations operating in ad-hoc mode or
as a mesh point.  Is there a reason this function is not supported in
those modes?  Is this a deliberate decision or just an oversight?

Thanks for your help.
