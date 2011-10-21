Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36060 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1JUIgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 04:36:10 -0400
Received: by yxl42 with SMTP id 42so1072169yxl.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 01:36:10 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Oct 2011 12:36:10 +0400
Message-ID: <CAG5dHkTg0JQK7d3jc1hO_A8xsPyogaufOnvvvas8Hx5GgFbskA@mail.gmail.com> (sfid-20111021_103614_209633_4C5A0FFE)
Subject: [RFC 0/7] mesh power saving implementation: indication
From: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

We have started implementation of power saving modes in mesh according
to chapter 11C.13 of the IEEE802.11s standard. We divided the work in
several phases and the first is indication of mesh STA's power save
modes in frames according to 11C.13.2 and 11C.13.3. We are very keen
to receive comments.

Thanks,
Ivan
