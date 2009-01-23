Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:31706 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbZAWQD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:03:59 -0500
Received: by yx-out-2324.google.com with SMTP id 8so2174695yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 08:03:58 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 23 Jan 2009 16:03:58 +0000
Message-ID: <e27b78a40901230803t8eafb3cx6d70ceaec68daf09@mail.gmail.com> (sfid-20090123_170405_462674_D7D24DD9)
Subject: Crashing on ping?
From: Keir <keirlawson@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just pulled the latest wireless-testing kernel, however, much like
the previous wireless-testing kernel I was working on, when attempting
to ping one node from another on a mesh, using ath5k, the node
attempting to ping completely freezes after about 7 pings are
(succesfully) sent.  Anyone have any idea what is going wrong here?

Cheers

Keir
