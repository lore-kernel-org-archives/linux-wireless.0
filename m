Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34669 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752499AbdLCVTh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Dec 2017 16:19:37 -0500
From: Vincent Legoll <vincent.legoll@gmail.com>
To: m@bues.ch, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Make SSB a menuconfig to ease disabling it all
Date: Sun,  3 Dec 2017 22:19:20 +0100
Message-Id: <20171203211921.20233-1-vincent.legoll@gmail.com> (sfid-20171203_222009_307640_DE0528B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


The following patch makes it easier to disable all SSB config
options without entering the submenu. It will also enable one
to see that en-disabled state from the outside menu.

This is only intended to change menuconfig UI, not change
the config dependencies.
