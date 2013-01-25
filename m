Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:43839 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3AYInZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 03:43:25 -0500
Received: by mail-bk0-f47.google.com with SMTP id jc3so63237bkc.20
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 00:43:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d8M6Gsv5-4j2H68+tr=cSVrz2A7Ow5xCmHuF_mEy-pb7w@mail.gmail.com>
References: <1359089270-29702-1-git-send-email-yeohchunyeow@gmail.com>
	<CAGXE3d8M6Gsv5-4j2H68+tr=cSVrz2A7Ow5xCmHuF_mEy-pb7w@mail.gmail.com>
Date: Fri, 25 Jan 2013 16:43:23 +0800
Message-ID: <CAEFj985hQGr2WhDXW9fS6_RDkOk1P4rF6TvtkcGvCiRds8nxpw@mail.gmail.com> (sfid-20130125_094335_038778_AF4D8B2D)
Subject: Re: [PATCH] rt2x00: allow AP and mesh mode to operate simultaneously
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	IvDoorn@gmail.com, gwingerde@gmail.com,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Just curios: Are you actually running mesh + ap mode on a rt2x00 device?

Yes. AP and Mesh created from the same radio are bridged together in
Fonera 2.0n. I have also tried this using the TP-Link USB adapter in a
PC. STA can associate with the AP and has its traffic forwarding via
mesh.

---
Chun-Yeow
