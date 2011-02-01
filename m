Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59362 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1BAQi0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 11:38:26 -0500
Received: by iyj18 with SMTP id 18so6123884iyj.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 08:38:26 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 1 Feb 2011 08:38:05 -0800
Message-ID: <AANLkTimSV7rHhdjWqfV5ujW6dd==BusmeC8fJOXGxfaT@mail.gmail.com>
Subject: Review of moving all DFS parameters to userspace
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I though we had reviewed the possibility of moving DFS parameters to
userspace but it seems that's not the case. We now at least know we
can keep the DFS regions: US, JP, ETSI, the next step is to determine
if the DFS parameters for these regions will come from userspace or
kernelspace. I'm inclined to support starting off with moving this to
kernelspace just to let us move forward with this support, and once in
kernel, review the possibility to move this out to userspace.

Thoughts?

 Luis
