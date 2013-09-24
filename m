Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f66.google.com ([209.85.215.66]:45332 "EHLO
	mail-la0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3IXSiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 14:38:04 -0400
Received: by mail-la0-f66.google.com with SMTP id er20so1223161lab.9
        for <linux-wireless@vger.kernel.org>; Tue, 24 Sep 2013 11:38:02 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 24 Sep 2013 20:38:02 +0200
Message-ID: <CAHDkEN-tDf27Og_tP5qdayaWD=-tD3yP921F5LLo6nTBEg-oow@mail.gmail.com> (sfid-20130924_203808_445823_44DEE252)
Subject: Frame injection at arbitrary rate
From: Rahim Rasheed <rahim.rasheed2@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was wondering why frame injection at arbitrary rates is not
supported. Radiotap properly supports 11g/a and 11n and it is working
on 11ac. Some time ago i saw a few submission of patches for adding
this feature for both 11g and 11n. I'm using the former without
problems. Is there a particular reason why these patches are held
back? I think they would be useful to many people.

Respectfully

R^2
