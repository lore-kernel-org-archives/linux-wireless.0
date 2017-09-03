Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:37416 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753090AbdICW7I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Sep 2017 18:59:08 -0400
Received: by mail-it0-f46.google.com with SMTP id k189so10978755itk.0
        for <linux-wireless@vger.kernel.org>; Sun, 03 Sep 2017 15:59:08 -0700 (PDT)
MIME-Version: 1.0
From: bruce m beach <brucembeach@gmail.com>
Date: Sun, 3 Sep 2017 15:59:07 -0700
Message-ID: <CAArymC=pZYpeA17T8c-bPH1ppjqzuwA0L_ObmdKYnOuih+YtAg@mail.gmail.com> (sfid-20170904_005913_573540_2A7F1E2F)
Subject: status of rtl8188eu driver
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

  Is the driver rtl8188eu supposed to be working at this point?
  I downloaded the driver, compiled it and started
  up the stick all without problems but when I started playing around
  with it I found things like 'iw' wouldn't recognize it, iwconfig and
  family did, it showed up in '/proc/net/wireless', would not respond to
  'iwconfig wlan0 essid "bismuth"' and so on.

Bruce
