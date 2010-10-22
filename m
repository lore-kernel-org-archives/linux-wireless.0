Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:56337 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0JVJc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 05:32:56 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by aurora.create-net.org (Postfix) with ESMTP id 59D37A78025
	for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 11:22:06 +0200 (CEST)
Received: from aurora.create-net.org ([127.0.0.1])
	by localhost (aurora.create-net.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1XDlAQJoznR3 for <linux-wireless@vger.kernel.org>;
	Fri, 22 Oct 2010 11:22:05 +0200 (CEST)
Received: from [192.168.9.199] (unknown [192.168.9.199])
	by aurora.create-net.org (Postfix) with ESMTPSA id 368F7A78024
	for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 11:22:05 +0200 (CEST)
Message-ID: <4CC157BC.6030007@create-net.org>
Date: Fri, 22 Oct 2010 11:22:04 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Support for rate and retries in injected frames
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

what is the consensus on this patch:

http://thread.gmane.org/gmane.linux.kernel.wireless.general/47441

I'm currently using it to support a custom routing protocol for
mesh networks which uses raw wireless interfaces to perform
link quality measurements (www.wing-project.org).

Thanks
R.
