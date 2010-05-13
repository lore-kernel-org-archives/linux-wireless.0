Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:38216 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab0EMQEn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 12:04:43 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by aurora.create-net.org (Postfix) with ESMTP id 09D4238478
	for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 18:04:42 +0200 (CEST)
Received: from aurora.create-net.org ([127.0.0.1])
	by localhost (aurora.create-net.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t-ZNodV3emjk for <linux-wireless@vger.kernel.org>;
	Thu, 13 May 2010 18:04:40 +0200 (CEST)
Received: from [192.168.9.133] (unknown [192.168.9.133])
	by aurora.create-net.org (Postfix) with ESMTPSA id C78A838476
	for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 18:04:40 +0200 (CEST)
Message-ID: <4BEC2318.5050701@create-net.org>
Date: Thu, 13 May 2010 18:04:40 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Strange ACK Behaviour with ath9k
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I'm having a very strange behaviour between two sr71a (ath9k) cards
operating in monitor mode. I'm using the following patch to specify
the transmission rate frame by frame:

http://thread.gmane.org/gmane.linux.kernel.wireless.general/47441


However if I try to send some traffic between the two nodes with both
interfaces operating in monitor mode I can see from a third machine
using wireshark that albeit the frame is sent and the corresponding
ack generated, the originator seems to ignore the ACK and keepts
retransmitting the frame. This is happening on both ends of the
communication (i'm ping one node from the other).

As a matter of fact i thought that ACK are handled directly by the
firmware. Any hints?

R.
