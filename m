Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:47590 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbZJ0Ukl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 16:40:41 -0400
Received: by qyk4 with SMTP id 4so79453qyk.33
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2009 13:40:46 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 27 Oct 2009 16:40:46 -0400
Message-ID: <86201b3f0910271340t51aa6c0bgff43e6e7211a0dee@mail.gmail.com>
Subject: iwlist wlan0 scan disrupts communications
From: Charles Gordon <digigordo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am using version 2.6.28 of the kernel and version 0.9.11-nogit of
iw.  Communications are disrupted and the device stops responding to
ping when I use the command "iwlist wlan0 scan".  Communications are
restored when the command completes.  Is this behavior expected?  Has
it been fixed in a later release?

Thanks for your help.
