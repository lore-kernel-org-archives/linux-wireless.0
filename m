Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40695 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab1EWPbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 11:31:02 -0400
Received: by vws1 with SMTP id 1so4168984vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 08:31:00 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 May 2011 23:31:00 +0800
Message-ID: <BANLkTimiWtkO3Utb_9dJGHJMyk+-HCaLdQ@mail.gmail.com> (sfid-20110523_173117_667515_B690782A)
Subject: How to get the noise for ralink3070 using driver rt2x00
From: zhang lei <zhanglei901@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can't get the noise value while using driver rt2x00 for the ralink
3070, but I can get it if use the official driver, and I saw the
article

 [PATCH] rt2x00: remove usage of deprecated noise value

said the noise field has deprecated.
Is there a new field for noise to instead of the old noise filed? How
can I get the noise value now?
