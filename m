Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.pens.ac.id ([202.9.85.49]:45636 "EHLO mail.pens.ac.id"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752973AbeE1Cng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 May 2018 22:43:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.pens.ac.id (Postfix) with ESMTP id D1EA72D4002
        for <linux-wireless@vger.kernel.org>; Mon, 28 May 2018 09:31:41 +0700 (WIT)
Received: from mail.pens.ac.id ([127.0.0.1])
        by localhost (mail.pens.ac.id [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8s+1rRofP5Pd for <linux-wireless@vger.kernel.org>;
        Mon, 28 May 2018 09:31:39 +0700 (WIT)
Received: from mail.pens.ac.id (mail.pens.ac.id [202.9.85.49])
        by mail.pens.ac.id (Postfix) with ESMTP id D83942D4001
        for <linux-wireless@vger.kernel.org>; Mon, 28 May 2018 09:31:39 +0700 (WIT)
Date: Mon, 28 May 2018 09:31:39 +0700 (WIT)
From: Ahmad Zainudin <zai@pens.ac.id>
To: linux-wireless@vger.kernel.org
Subject: hostapd.config file for ACS Configuration
Message-ID: <cc7169c6-2204-4ba0-9e68-7446f5b7d11a@mail.eepis-its.edu> (sfid-20180528_044528_155729_194846E9)
Content-Type: text/plain; charset=utf-8
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I install hostapd use apt-get install

>From tutorial for ACS (Automatic Channel Selection) configuration, I must enable ACS in hostapd's .config file :

CONFIG_ACS=y

I have trouble finding  hostapd.config file too enable CONFIG_ACS=y. I have finish configure  channel=acs_survey in hostapd.conf file.

Are the hostapd.config and hostapd.conf different files?, and I am not yet found the  hostapd.config file.

Can help me?
Thank you,,

---------------------------------------------------------------
Ahmad Zainudin
Digital Signal Processing Lab. E-206
Telecommunication Engineering Department
Electronic Engineering Polytechnic Institute of Surabaya (EEPIS)
http://zai.lecturer.pens.ac.id



---------------------------------------------------------------------
PENS/EEPIS - Bridge To The Future
Politeknik Elektronika Negeri Surabaya (PENS)
Electronic Engineering Polytechnic Institute of Surabaya (EEPIS)
http://www.pens.ac.id
