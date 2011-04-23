Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout5.freenet.de ([195.4.92.95]:55222 "EHLO mout5.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757295Ab1DWW1W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Apr 2011 18:27:22 -0400
Received: from [195.4.92.28] (helo=18.mx.freenet.de)
	by mout5.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QDlIO-00058f-Ux
	for linux-wireless@vger.kernel.org; Sun, 24 Apr 2011 00:27:20 +0200
Received: from p54a1975e.dip0.t-ipconnect.de ([84.161.151.94]:57659 helo=mail.maya.org)
	by 18.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QDlIO-0004Ui-MP
	for linux-wireless@vger.kernel.org; Sun, 24 Apr 2011 00:27:20 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p3NMRGdd005152
	for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 00:27:17 +0200
Message-ID: <4DB352B3.9060807@01019freenet.de>
Date: Sun, 24 Apr 2011 00:29:07 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: building compat-wireless-2011-04-23 fails with 2.6.38.4
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I got the following erros compiling compat-wireless-2011-04-23:

CC [M]  /Downloads/compat-wireless-2011-04-23/compat/main.o
In file included from
/Downloads/compat-wireless-2011-04-23/include/linux/compat-2.6.h:34:0,from
<command-line>:0:
/Downloads/compat-wireless-2011-04-23/include/linux/compat-2.6.39.h:103:32:
error: redefinition of ‘kstrtoul’
/usr/src/linux-2.6.38.4-1/include/linux/kernel.h:197:32: note: previous
definition of ‘kstrtoul’ was here
/Downloads/compat-wireless-2011-04-23/include/linux/compat-2.6.39.h:116:32:
error: redefinition of ‘kstrtol’
/usr/src/linux-2.6.38.4-1/include/linux/kernel.h:210:32: note: previous
definition of ‘kstrtol’ was here
/Downloads/compat-wireless-2011-04-23/include/linux/compat-2.6.39.h:132:32:
error: redefinition of ‘kstrtou64’
/usr/src/linux-2.6.38.4-1/include/linux/kernel.h:226:32: note: previous
definition of ‘kstrtou64’ was here
/Downloads/compat-wireless-2011-04-23/include/linux/compat-2.6.39.h:137:32:
error: redefinition of ‘kstrtos64’
/usr/src/linux-2.6.38.4-1/include/linux/kernel.h:231:32: note: previous
definition of ‘kstrtos64’ was here
/Downloads/compat-wireless-2011-04-23/include/linux/compat-2.6.39.h:142:32:
error: redefinition of ‘kstrtou32’
/usr/src/linux-2.6.38.4-1/include/linux/kernel.h:236:32: note: previous
definition of ‘kstrtou32’ was here
/Downloads/compat-wireless-2011-04-23/include/linux/compat-2.6.39.h:147:32:
error: redefinition of ‘kstrtos32’
/usr/src/linux-2.6.38.4-1/include/linux/kernel.h:241:32: note: previous
definition of ‘kstrtos32’ was here
make[5]: *** [/Downloads/compat-wireless-2011-04-23/compat/main.o] Fehler 1
make[4]: *** [/Downloads/compat-wireless-2011-04-23/compat] Fehler 2


Could you please take a look at this problem?


Thank you,
Andreas
