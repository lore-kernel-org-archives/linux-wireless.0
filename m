Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from maquina46.madrimasd.org ([193.145.15.46]:28555 "EHLO
	estafeta.imdea.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab2EPRhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 13:37:37 -0400
Received: from localhost (estafeta21.imdea.org [172.17.99.144])
	by estafeta21.imdea.org (Postfix) with ESMTP id B721718AA09
	for <linux-wireless@vger.kernel.org>; Wed, 16 May 2012 19:03:38 +0200 (CEST)
Received: from estafeta.imdea.org ([172.17.99.144])
	by localhost (estafeta21.imdea.org [172.17.99.144]) (amavisd-new, port 10024)
	with ESMTP id Dx12b3F8QfCQ for <linux-wireless@vger.kernel.org>;
	Wed, 16 May 2012 19:03:38 +0200 (CEST)
Received: from [163.117.140.219] (unknown [163.117.140.219])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: josepablo.salvador)
	by estafeta21.imdea.org (Postfix) with ESMTP id 877CA18AA08
	for <linux-wireless@vger.kernel.org>; Wed, 16 May 2012 19:03:38 +0200 (CEST)
Message-ID: <4FB3DE86.1030204@imdea.org> (sfid-20120516_193741_480125_95A99F8C)
Date: Wed, 16 May 2012 19:06:14 +0200
From: Pablo Salvador <josepablo.salvador@imdea.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Trigger the transmission of a mgmt frame at user space
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm trying to trigger the transmission of a management frame at the user 
space using iw. My problem or doubts is to see if it is feasible. I'm a 
bit lost on how to generate the callback, by means of netlink, in order 
to communicate 'iw' with the cfg80211 module.

Thanks in advance

Best,

Pablo
